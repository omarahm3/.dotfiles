#!/usr/bin/python3

import os
import re
import json
from datetime import datetime
import requests

home = os.path.expanduser("~")
url = "https://mawaqit.net/en/alhijra-leiden"


def main():
    now = datetime.now()
    today_string = now.strftime("%D")
    log_path = f"{home}/.cache/salat.log"

    if not os.path.exists(log_path) or not os.path.getsize(log_path):
        make_log(log_path, today_string)

    if today_string != json.load(open(log_path, "r", encoding="utf-8"))["today"]:
        make_log(log_path, today_string)

    with open(log_path, "r", encoding="utf-8") as log_file:
        log_load = json.load(log_file)
        salat_times = log_load["salat_table"]
        get_next_salat(now, salat_times)


def make_log(log_path, today_string):
    data = {"today": today_string, "salat_table": parse()}

    with open(log_path, "w", encoding="utf-8") as log_file:
        json.dump(data, log_file)


def get_next_salat(now: datetime, times):
    time_list = [
        now.replace(hour=int(t[:-3]))
        .replace(minute=int(t[3:]))
        .replace(second=0)
        .replace(microsecond=0)
        for t in times
    ]

    for t in time_list:
        delta = str(t - now)
        if delta[0] != "-":
            print("> " + delta[:4])
            return delta[:4]

    print(str(time_list[0])[11:-3])


def parse():
    response = requests.get(url)
    regex_data = re.findall(r"times\":\[(.*?)\]", response.text)
    times = str(regex_data[0])[1:-1].replace('"', "").split(",")

    return times


if __name__ == "__main__":
    main()
