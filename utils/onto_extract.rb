#!/usr/bin/env ruby

require 'rdf'
require 'rdf/rdfxml'
require 'json'
require 'json/ld'
require 'net/http'
require 'uri'
require 'erb'
require 'pry'

# Script create a grep or awk file to facilitate finding non-ontology URIs
# Ontology remotes
CPO_URI = "https://raw.githubusercontent.com/Display-Lab/cpo/master/cpo.owl"
PSDO_URI = "https://raw.githubusercontent.com/Display-Lab/psdo/master/psdo.owl"
SLOWMO_URI = "" # skip slomo until it's syntax is fixed


# Debugging convenience function to read ontologies from disk
# Return local file name
def retrieve_ontology(uri)
  case uri
  when CPO_URI
    file_path = "/home/grosscol/workspace/ontologies/cpo/cpo.owl"
  when PSDO_URI
    file_path = "/home/grosscol/workspace/ontologies/psdo/psdo.owl"
  else
    puts "bad uri"
    abort
  end

  #File.read file_path
end

# Create a hash of IRI => labels from the graph of an ontology.
def extract_uris( graph )  
  graph.terms.map{|t| t.to_s if t.uri?}.compact
end

# Load Ontologies
#   Grab from hard coded local location for now.
#   Use fetch_ontology to grap from remote
cpo_owl  = retrieve_ontology CPO_URI
psdo_owl = retrieve_ontology PSDO_URI

cpo_graph  = RDF::Graph.load(cpo_owl,  format: :rdfxml)
psdo_graph = RDF::Graph.load(psdo_owl, format: :rdfxml)

cpo_uris  = extract_uris cpo_graph
psdo_uris = extract_uris psdo_graph

puts cpo_uris.concat(psdo_uris).uniq
