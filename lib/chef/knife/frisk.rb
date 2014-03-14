require 'chef/knife'

module KnifeFrisk
  class Frisk < Chef::Knife

    deps do
     require 'chef/search/query'
    end

    banner 'knife frisk (options)'

    def run
      nodes = {}
      machines = rest.get('data/notes/machines')['machines']
      q = Chef::Search::Query.new
      q.search(:node, '*:*') do |node|
        n = machines[node.name].nil? ? {} :  machines.delete(node.name)

        ['fqdn', 'hostname', 'ipaddress', 'roles'].each do |attribute|
          if node.attribute? attribute
            n[attribute] = node.attributes[attribute]
          end
        end
        if node.attribute? 'virtualization'
          unless node.attributes.virtualization.empty?
            n['virtualization'] ||= {}
            unless (node.attributes.virtualization.keys & ['kvm','xen']).empty?
              n['virtualization']['guests'] ||= []
              node.attributes.virtualization.kvm.guests.each do |k,v|
                n['virtualization']['guests'] << {
                  k.to_sym => { state: v.state }
                }
              end
            end
            n['virtualization']['role'] = node.attributes.virtualization.role
            n['virtualization']['system'] = node.attributes.virtualization.system
          end
        end
        nodes[node.name] = n
      end

      # add remaining machines that are not being managed by chef
      nodes.merge! machines unless machines.empty?

      ui.output nodes
    end
  end

end
