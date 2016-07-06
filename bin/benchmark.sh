#!/bin/bash

cd $(dirname "$0")/../test/dummy_app

BUNDLE_GEMFILE=../../Gemfile bundle e rails r bin/bench.rb
