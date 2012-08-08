module ActionView
  module Helpers
    module FormHelper
      def datetime_field(object_name, method, options = {})
        object = self.instance_variable_get("@#{object_name}")
        value = object.send(method)

        format = options.key?(:format) ? options.delete(:format) : nil
        if value.is_a?(Time) or value.is_a?(DateTime)
          if format.blank?
            value = value.to_s(:default)
          elsif format.is_a?(Symbol)
            value = value.to_s(format)
          else
            value = value.strftime(format)
          end
        end
        InstanceTag.new(object_name, method, self, options.delete(:object)).to_input_field_tag("text", options.update({:value => value}))
      end
    end

    class FormBuilder
      def datetime_field(method, options = {})
        @template.datetime_field(@object_name, method, options.merge(:object => @object))
      end
    end

  end
end
