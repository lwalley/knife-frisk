require 'chef/knife'

module KnifeFrisk
  class FriskCreate < Chef::Knife

    banner 'knife frisk create (options)'

    def run
      nodes = rest.get_rest(:nodes)
      n = {}
      nodes.each do |k,v|
        n[k] = {}
      end
      ui.output(Hash[*n.sort.flatten].to_json)
    end
  end
end
