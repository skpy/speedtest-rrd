# Speedtest RRD

This is a simple Python script to run speedtest-cli and feed the results into a round robin database to be consumed by `rrdtool`.

By default this script will sleep for a random number of seconds, up to 30 minutes, to ensure that test execution is skewed over time. Execution can be performed immediately with the `-n` flag.

`speedtest-graph.sh` creates daily, weekly, monthly and annual graphs. You are on your own to embed these as you desire in a status report or web page.

## Installation
* Clone this repo
* Install [speedtest-cli](https://github.com/sivel/speedtest-cli)
* Create an rrd file, with three `gauge` data sources: ping, down, and up
* Set up a cron job

I run this script every 4 hours:
```
1 */4 * * * /home/skippy/bin/speedtest.py -r /home/skippy/rrd/speedtest.rrd && /home/skippy/bin/speedtest-graph.sh /home/skippy/rrd/speedtest.rrd /var/www/html/stats/
```

