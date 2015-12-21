#!/bin/bash

while [ true ]; do
  timestamp=`date +"%Y%m%d_%0k%M%S"`
  ruby fetch_congress.rb > tracking/congress_results_$timestamp.csv &
  ruby fetch_senate.rb > tracking/senate_results_$timestamp.csv &
  sleep 300
done
