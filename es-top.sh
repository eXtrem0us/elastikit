#!/bin/bash

escurl /_cat/indices?v|awk 'NR<2{print $0;next}{print $0| "sort -rnk7,7"}'
