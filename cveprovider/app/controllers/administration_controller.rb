require_relative '../../cveparser/parser'

class AdministrationController < ApplicationController
  def parser_index
  end

  def parse_file
    include NVDPARSER
  end
end
