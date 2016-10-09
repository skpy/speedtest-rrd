#!/usr/bin/env python
import json, random, speedtest_cli, subprocess, sys, time
from cStringIO import StringIO
from optparse import OptionParser

def build_parser():
  parser = OptionParser()
  parser.add_option('-r', '--rrd', dest='rrd', help='Path to rrd file', type='string')
  parser.add_option('-n', '--now', dest='now', help='Do not randomly sleep, execute now', action='store_true')
  return parser

def main():
  parser = build_parser()
  options, _args = parser.parse_args()
  if not options.rrd:
    parser.error('rrd file is required')

  if not options.now:
    # sleep for a random number of seconds, up to thirty minutes
    # to ensure this is not at a predictable time every time
    random.seed()
    time.sleep(random.randint(1,1800))

  # capture stdout, so that we can parse the speedtest output
  # http://stackoverflow.com/a/22823751/3297734
  old_stdout = sys.stdout
  sys.stdout = mystdout = StringIO()

  # tell speedtest that we want simple output
  sys.argv=['prog', '--simple']
  try:
    speedtest_cli.speedtest()
    results = mystdout.getvalue().splitlines()
    ping = float(results[0].split(' ')[1])
    download = float(results[1].split(' ')[1])
    upload = float(results[2].split(' ')[1])
  except:
    ping = 'U'
    download = 'U'
    upload = 'U'

  # restore stdout
  sys.stdout = old_stdout


  data="N:%f:%f:%f" % (ping, download, upload)
  subprocess.call(['/usr/bin/rrdupdate', str(options.rrd), data])

if __name__ == "__main__":
  main()
