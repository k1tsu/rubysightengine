require "json"

# The Checked class, used for handling responses.
class Checked  

    # Creates a new Checked object.
    # @param data [String] the data from the request.
    # @param min [Float] the minimum score from the content filter that will pass.
    def initialize(data, min=0.9)

        @raw = JSON.parse(data)
        @min = min 
        @type = @raw.keys.delete_if {|h| ["status", "media", "request"].include? h}
        
    end 

    # Changes the testing value minimum content is compared against. 
    # @param min [Float] the minimum score.
    def set_min(min)

        @min = min 

    end 

    # Returns the raw JSON parsed data
    # @return [Hash] 
    def raw

        @raw

    end 

    # Returns the statistic hash of each given type.
    # @param type [string] the types of content filters.
    # @return [Array]
    def stat_hash(*type)

        if type === []
            type = @type 
        end 

        return type.map {|t| @raw[t]}

    end 

    # Returns all box coordinates from location based filters.
    # @return [Array]
    def boxes 

        all_boxes = []
        @raw.each do |h|

            if ["status", "media", "request"].include?(h[0]) == false && h[1]['boxes'] != nil 
                all_boxes << h[1]['boxes'][0]   
            end  
        end 
        return all_boxes
    end 

    # Checks if response has filter type. You can include multiple types. 
    # @param type [string] the types of content filters. 
      def has?(*type)

        if type === []
            type = @type
        end

        checker = {}

        type.each do |t|

            if @raw.keys.include? t 

                avg = 0 
                current = @raw[t]

                current.keys.each do |stat|
            
                    misc = nil 

                    if stat != "safe" and stat != "boxes"

                        avg += current[stat] 
                        
                    end 

                end 
              
                if (avg/current.delete_if {|x| x === "safe"}.count) <= @min
                    checker[t] = false 
                else
                    checker[t] = true
                end 

            else 

                raise "sightengine category '#{t}' not found, check spelling?"

            end

        end 

        checker
        # @return [Array] 

    end 

    #Checks if image has 'safe' key and compares it to minimum score.
    # @param type [string] the types of content filters.
    # @return [Array]  
    def safe?(*type)

        if type === []
            type = @type 
        end 

        type.delete_if {|t| @raw[t]['safe'] === nil}
        type.map {|t| [t, (@raw[t]['safe'] >= @min)]}.to_h

    end 

end 





