require 'net/http'
require_relative "checked.rb"

 
# The sightengine class.
class SightEngineE

    # The sightengine endpoint.
    BASE_URL = "https://api.sightengine.com/1.0/check.json"

    # The valid categories that sightengine api takes.
    VALID_CATEGORIES = [
        "nudity", 
        "wad", 
        "properties", 
        "celebrities", 
        "offensive", 
        "faces", 
        "scam", 
        "text-content", 
        "face-attributes", 
        "text"
    ] 

    # Creates a new sightengine object with credentials and an optional workflow.

    # @param [String] api_user the api_user credential provided by sightengine. 
    # @param api_secret [String] the api_secret credential provided by sightengine. 
    # @param worklfow [String] the workflow you have created in the sightengine interface, this is optional. 
    def initialize(api_user, api_secret, workflow=nil)

        @api_user = api_user
        @api_secret = api_secret
        @workflow = nil 
        @min = 0.9     

    end

    # Sets the workflow for the class.
    # @param workflow [String] the target workflow to set as the class workflow.
    def set_workflow(workflow)

        @workflow = workflow

    end 
    
    # Checks a image for any content by making an HTTP request to the sightengine servers.
    # @param target_url [String] the url of the target image.
    # @param type [String] the type of content to be scanned for. 
    def check(target_url, *type)

 
        if type.any? {|t| VALID_CATEGORIES.include?(t) === false}

            raise "while checking, one or more of your sightengine types were not found"

        end

        uri = URI("https://api.sightengine.com/1.0/check.json")

        form_h = {api_user: @api_user, api_secret: @api_secret, url: target_url} 
        form_h[:workflow] = @workflow if @workflow != nil
        form_h[:models] = type.join(",")
        uri.query = URI.encode_www_form(form_h)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = (uri.scheme == 'https')

        request = Net::HTTP::Get.new(uri)
        request.body = ""
        request.add_field 'Accept', 'application/json'
        response = http.request(request)

        if response.is_a?(Net::HTTPSuccess) === false 
            raise "sightengine server gave a #{response.code} error: #{response.msg}"
        end 

        # @return [Checked] if request is 200 
        return Checked.new(response.body)

    end

end 
