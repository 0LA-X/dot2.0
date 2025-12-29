#!/bin/bash

set -e

pkill swww && swww-daemon --format xrgb
