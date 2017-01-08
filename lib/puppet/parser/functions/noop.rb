# Set noop to true as default for current and children scopes, or 'reset' an inherited default with noop(false)
Puppet::Parser::Functions::newfunction(:noop, :doc => "Set noop default for all resources
  in local scope and children scopes. This can be overriden in
  child scopes, or explicitly on each resource.
  ") do |args|
      @noop_value = true if (@noop_value = args[0]).nil? or (![true, false].include? @noop_value) or Facter.value('clientnoop')
  class << self
    def lookupdefaults(type)
      values = super(type)

      # Create a new :noop parameter with the specified value (true/false) for our defaults hash
      noop = Puppet::Parser::Resource::Param.new(
        :name => :noop, :value => @noop_value, :source => self.source )

      # Replace whatever defaults we recieved
      values[:noop] = noop
      values
    end
  end
end
