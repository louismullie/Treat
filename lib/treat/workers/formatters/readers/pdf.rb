# encoding: utf-8
# A wrapper for the Poppler pdf2text utility, which
# extracts the text from a PDF file.
module Treat::Workers::Formatters::Readers::PDF

  # Read a PDF file using the Poppler pdf2text utility.
  #
  # Options: none.
  def self.read(document, options = {})
    
    create_temp_file(:txt) do |tmp|
      
      `pdftotext #{document.file} #{tmp} `.strip
      f = File.read(tmp)
      f.gsub!("\t\r ", '')
      f.gsub!('-­‐', '-')
      f.gsub!("\n\n", '#keep#')
      f.gsub!("\n", ' ')
      # Fix for an incompatible space character.
      f.gsub!(" ", ' ')  
      f.gsub!('#keep#', "\n\n")
      
      document.value = f
      document.set :format, :pdf
      document
      
    end
    
  end

end