module VagrantPlugins
  module Haipa
    module Action
      class MessageAlreadyCreated
        def initialize(app, _)
          @app = app
        end

        def call(env)
          env[:ui].info(I18n.t('vagrant_haipa.info.already_status', :status => "created"))
          @app.call(env)
        end
      end
    end
  end
end
