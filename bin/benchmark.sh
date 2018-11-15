#!/bin/bash

cd $(dirname "$0")/../test/dummy_app

BUNDLE_GEMFILE=../../gemfiles/benchmark.gemfile bundle e rails r bin/bench.rb
