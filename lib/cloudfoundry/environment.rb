require "json"
require "hashie"

module CloudFoundry
  class Environment

    class << self

      def port
        raw_port = ENV["VCAP_APP_PORT"]
        raw_port.to_i if raw_port
      end

      def host
        ENV["VCAP_APP_HOST"]
      end

      def instance_index
        return app_info.instance_index if app_info
      end


      def app_info
        raw_vcap_app = ENV["VCAP_APPLICATION"]
        Hashie::Mash.new(JSON.parse(raw_vcap_app)) if raw_vcap_app
      end

      def running_local?
        app_info.nil?
      end

      def services
        svcs_raw = ENV["VCAP_SERVICES"]
        Hashie::Mash.new(JSON.parse(svcs_raw)) if svcs_raw
      end

      def method_missing(id, *args)
        index = args[0] || 0
        if id =~ /([^_]+)_cnx$/
          return service_cnx(Regexp.last_match(1), index)
        elsif id =~ /([^_]+)_info$/
          return service_info(Regexp.last_match(1), index)
        end
        raise NoMethodError
      end

      def service_cnx(service_regexp, index = 0)
        if services and services.count > 0
          svc_key = services.keys.find {|svc| svc =~ /#{service_regexp}/i }
          if svc_key and index < services[svc_key].length
            return Hashie::Mash.new(services[svc_key][index][:credentials])
          end
        end
      end

      def service_info(service_regexp, index = 0)
        if services and services.count > 0
          svc_key = services.keys.find {|svc| svc =~ /#{service_regexp}/i }
          if svc_key and index < services[svc_key].length
            return Hashie::Mash.new(services[svc_key][index])
          end
        end
      end

      def raw_uris
        app_info.uris if app_info
      end

      def raw_app_version
        app_info.version if app_info
      end

      def is_prod_app?(base = "www")
        staging_regex = /^#{base}[0-9]?([^\.]?)(\..*)$/
        !raw_uris.find{|uri| uri =~ staging_regex}.nil? if raw_uris
      end

    end
  end
end
