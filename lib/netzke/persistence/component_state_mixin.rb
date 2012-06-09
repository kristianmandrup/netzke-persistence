module Netzke
  module Persistence
    module ComponentStateMixin
      def propagate(hsh)
        return unless masquerade? && masqueraded_user_id

        propagations.all.each do |r|
          r.value = r.value.merge(hsh)
          r.save!
        end
      end

      def propagations
        masqueraded_role ? user_component_that_masquerades_as_role(with_matching_component) : with_matching_component
      end

      def with_matching_component
        self.where :component => component
      end

      def user_component_that_masquerades_as_role relation
        raise NotImplementedError, "Must be implemented by including class"
      end

      # if role is string
      def masqueraded_role
        @masqueraded_role ||= masquerade_as[:role]
      end

      # if role is relation
      def masqueraded_role_id
        @masqueraded_role_id ||= masquerade_as[:role_id]
      end

      def masqueraded_user_id
        @masqueraded_user_id ||= masquerade_as[:user_id]
      end

      def masquerade_as_world?
        @masquerade_as_world ||= masquerade_as[:world]
      end

      def find_state or_create_new = false
        self.where(state_hash).first || (or_create_new ? self.new(state_hash) : nil)
      end

      def masquerade?
        masquerade_as.present?
      end

      def state_hash
        @state_hash ||= masquerade? ? masquerade_hash(component_hash) : user_hash(component_hash)
      end

      def component_hash
        {:component => component}
      end

      def user_hash hash
        return hash unless current_user
        hash.merge(:user_id => current_user.id)
      end

      def masquerade_hash hsh
        return hsh.merge(:role_id => 0) if masquerade_as_world?
        return hsh.merge(:role_id => masqueraded_role_id) if masqueraded_role_id
        return hsh.merge(:user_id => masqueraded_user_id) if masqueraded_user_id
      end
    end
  end
end