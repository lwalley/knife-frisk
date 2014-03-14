require 'chef/knife'

module KnifeFrisk

  class FriskShow < Chef::Knife

    deps do
     require 'chef/search/query'
    end

    banner 'knife frisk show NODE_NAME (options)'

    def run
      if name_args.empty?
        ui.fatal 'Missing node name: knife frisk show NODE_NAME.'
        exit 1
      end

      name = name_args.first
      machine = rest.get('data/notes/machines')['machines'].select{|k,v| k == name}
      q = Chef::Search::Query.new
      q.search(:node, "name:#{name}") do |node|
        next unless node.name == name
        machine[name] ||= {}
        ['fqdn', 'hostname', 'ipaddress', 'roles'].each do |attribute|
          if node.attribute? attribute
            machine[name][attribute] = node.attributes[attribute]
          end
        end
        if node.attribute? 'virtualization'
          unless node.attributes.virtualization.empty?
            machine[name]['virtualization'] ||= {}
            unless (node.attributes.virtualization.keys & ['kvm','xen']).empty?
              machine[name]['virtualization']['guests'] ||= []
              node.attributes.virtualization.kvm.guests.each do |k,v|
                machine[name]['virtualization']['guests'] << {
                  k.to_sym => { state: v.state }
                }
              end
            end
            machine[name]['virtualization']['role'] = node.attributes.virtualization.role
            machine[name]['virtualization']['system'] = node.attributes.virtualization.system
          end
        end
      end

      ui.output machine
    end

  end

end
