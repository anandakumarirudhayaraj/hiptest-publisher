require 'yaml'
require 'digest/md5'

module Hiptest
  class SignatureExporter
    def self.export_actionwords(project, export_nodes = false)
      exporter = SignatureExporter.new
      exporter.export_actionwords(project.children[:actionwords], export_nodes)
    end

    def export_actionwords(aws, export_nodes = false)
      aws.children[:actionwords].map {|aw| export_actionword(aw, export_nodes)}
    end

    def export_item(item, export_node = false)
      hash = {
        'name' => item.children[:name],
        'uid' => item.children[:uid],
        'parameters' => export_parameters(item),
        'body_hash' => make_body_hash(item.children[:body])
      }
      hash['node'] = item if export_node
      hash
    end
    alias :export_actionword :export_item
    alias :export_scenario :export_item

    def export_parameters(item)
      item.children[:parameters].map {|p| export_parameter(p)}
    end

    def export_parameter(parameter)
      {
        'name' => parameter.children[:name]
      }
    end

    def make_body_hash(body)
      Digest::MD5.hexdigest(body.map(&:flat_string).join(''))
    end
  end
end
