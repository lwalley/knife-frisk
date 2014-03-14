require 'chef/knife'

module KnifeFrisk
  class FriskList < Chef::Knife

    banner 'knife frisk list (options)'

    def run
      machines = rest.get('data/notes/machines')['machines'].keys
      nodes = rest.get_rest(:nodes).keys
      ui.output machines | nodes
    end

  end
end
