# encoding:utf-8

# require lib dir
require './lib/app'
require 'rack'
require 'sinatra'
lib_dir    = File.expand_path("../lib", __FILE__)
config_dir = File.expand_path("../config", __FILE__)
$: << lib_dir unless $:.include?(lib_dir)
$: << config_dir

run FacebookStats
