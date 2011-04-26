class AdminController < ApplicationController
  layout "admin"

  def index
    # if any
  end

  Everything = [:index, :new, :create, :show, :edit, :update, :destroy]

  class << self
    def _stem
      self.to_s.match(/(?::|\A)([^:]+)Controller\z/)[1]
    end
    def model_name
      _stem.sub(/s\z/,'').gsub(/([a-z])([A-Z])/){ "#{$1}_#{$2}" }.downcase
    end
    def model
      Object.const_get _stem.sub(/s\z/,'').intern
    end
    def does *a
      opts = (a.last.kind_of?(Hash) ? a.pop : {}).dup
      opts[:with]  ||= model_name
      opts[:model] ||= model
      [:everything] == a and a = Everything
      opts[:except] and a = _except(a, opts[:except])
      a.each do |meth|
        define_method meth, send("_#{meth}", "@#{opts[:with]}", opts[:model])
      end
    end
    def _except a, except
      a = a.dup
      except.each do |m|
        fail("not there: #{m.inspect}") unless(i = a.index(m))
        a[i] = nil
      end
      a.compact
    end
    def _index v, model
      v = "#{v}s"
      lambda { respond_with instance_variable_set(v, model.all) }
    end
    def _new v, model
      lambda { respond_with instance_variable_set(v, model.new) }
    end
    def _create v, model
      mn = model_name
      lambda do
        x = instance_variable_set v, model.new(params[mn])
        x.save
        respond_with :admin, x
      end
    end
    def _show v, model
      lambda { respond_with instance_variable_set(v, model.find(params[:id])) }
    end
    def _edit v, model
      lambda { respond_with instance_variable_set(v, model.find(params[:id])) }
    end
    def _update v, model
      mn = model_name
      lambda do
        x = instance_variable_set(v, model.find(params[:id]))
        x.update_attributes params[mn]
        respond_with :admin, x
      end
    end
    def _destroy v, model
      lambda do
        x = instance_variable_set(v, model.find(params[:id]))
        x.destroy
        respond_with :admin, x
      end
    end
  end
end
