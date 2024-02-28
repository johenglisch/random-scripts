#!/usr/bin/env python3

import os
import re
import sys
import textwrap
import zoneinfo
from datetime import datetime, timedelta
from pathlib import Path
from urllib.request import urlopen


RE_ROUTE = re.compile(r'"teaser__link"[ \n]*href="(/multimedia/sendung/tagesschau_20_uhr/ts-[0-9]+\.html)')
RE_DATE = re.compile(r'class="teaser__date">[ \n]*(\d+)\.(\d+)\.(\d+)')
RE_TOPICS = re.compile(
    '<p><strong>Themen der Sendung:</strong>.*?</p>',
    re.IGNORECASE | re.DOTALL)


def read_cached_topics(file_path):
    if file_path.exists():
        with file_path.open(encoding='utf-8') as db_file:
            return dict(
                line.strip().split(': ', maxsplit=1)
                for line in db_file)
    else:
        return {}


def write_cached_topics(file_path, cached_topics):
    file_path.parent.mkdir(parents=True, exist_ok=True)
    with file_path.open('w', encoding='utf-8') as db_file:
        print(
            '\n'.join(f'{k}: {v}' for k, v in cached_topics.items()),
            file=db_file)


def retrieve_topic_list_from_the_internets(desired_date):
    url = 'https://www.tagesschau.de/multimedia/sendung/tagesschau_20_uhr'
    with urlopen(url) as conn:
        overview_page = conn.read().decode('utf-8')
    if (episode_match := RE_ROUTE.search(overview_page)):
        episode_route = episode_match.group(1)
    else:
        raise ValueError("couldn't find episode link")
    if (date_match := RE_DATE.search(overview_page)):
        day, month, year = date_match.groups()
        episode_date = '%04d-%02d-%02d' % (int(year), int(month), int(day))
    else:
        raise ValueError("couldn't find episode date")
    if episode_date != desired_date:
        raise ValueError(
            "couldn't find episode from {} (latest episode is from {})".format(
                desired_date,
                episode_date))

    with urlopen(f'https://tagesschau.de{episode_route}') as conn:
        episode_page = conn.read().decode('utf-8')
    if (topics_match := RE_TOPICS.search(episode_page)):
        topics = re.sub(r'<[^>]*>', '', topics_match.group(0))
    else:
        raise ValueError("couldn't find topic list")
    return topics


def latest_date():
    # new episode comes out at 20:00 CET
    cet = zoneinfo.ZoneInfo('Europe/Berlin')
    now = datetime.now(cet)
    if now.hour < 20:
        return (now - timedelta(days=1)).strftime('%Y-%m-%d')
    else:
        return now.strftime('%Y-%m-%d')


def main():
    if len(sys.argv) > 1:
        desired_date = sys.argv[1].strip()
    else:
        desired_date = latest_date()
        assert re.fullmatch(r'\d\d\d\d-\d\d-\d\d', desired_date)
    if not re.fullmatch(r'\d\d\d\d-\d\d-\d\d', desired_date):
        print('usage:', sys.argv[0], '[YYYY-MM-DD]', file=sys.stderr)
        sys.exit(64)

    if (dir_from_env := os.environ.get('XDG_DATA_HOME')):
        data_dir = Path(dir_from_env)
    else:
        data_dir = Path.home() / '.local' / 'share'
    db_file = data_dir / 'tagesschau-themen' / 'themen.txt'
    cached_topics = read_cached_topics(db_file)

    if desired_date in cached_topics:
        topics = cached_topics[desired_date]
    else:
        try:
            topics = retrieve_topic_list_from_the_internets(desired_date)
        except ValueError as err:
            print(err, file=sys.stderr)
            sys.exit(74)
        cached_topics[desired_date] = topics
        write_cached_topics(db_file, cached_topics)

    print('\n'.join(textwrap.wrap(topics, width=80)))


if __name__ == '__main__':
    main()
