require 'digest/sha2'

module LocalEngine
  module Analytics
    # Helper methods for subclasses of ActionController::Base.
    #
    # In order to collect analytics data, the application can
    # create a persistent Analytics::Episode which acts as a
    # collection point for data on a user's actions over a
    # single session of website user.
    #
    # The methods in this module allow a controller instance to
    # create, persist, store, and manipulate Analytics::Episodes:
    #
    #   class ApplicationController < ActionController::Base
    #     before_filter :setup_analytics
    #     after_filter  :record_analytics_event
    #   end
    module Filters
      private
      # Sets up a new or existing analytics episode for access.
      #
      # @return [Analytics::Episode]
      def setup_analytics
        returning create_or_load_analytics_episode do |episode|
          session[:analytics_uuid] = episode.uuid
          @analytics               = episode
        end
      end

      # Loads an analytics episode if one exists; otherwise
      # creates a new episode. Will raise an error if the app
      # fails to create a new episode.
      #
      # @return [Analytics::Episode]
      def create_or_load_analytics_episode
        if uuid = session[:analytics_uuid]
          ::Analytics::Episode.find_by_uuid(uuid)
        else
          ::Analytics::Episode.create!
        end
      end
      
      # Records a page view event in association with the current
      # user, grouped under the current analytics episode.
      #
      # @see Analytics::Episode#add_event
      def record_analytics_event
        @analytics.add_event(request)
      end      
      
      # Voids the current analytics episode. Future controller actions
      # will need to call +setup_analytics+ to restart the analytics process.
      #
      # May be needed on logout.
      def reset_analytics_episode
        @analytics = nil
        session[:analytics_id] = nil
      end
    end
    
    # Helper methods for creating unique identifiers for database models.
    #
    # We can use Universally Unique Identifiers (UUIDs) instead of database IDs
    # to avoid exposing the database ID's via cookies. This is a very rough UUID
    # implementation but does the job of creating unique identifiers for our
    # own database records.
    #
    # @see http://en.wikipedia.org/wiki/Universally_unique_identifier
    module UUID
      private
      # todo:3: if we switch to database sessions, we can probably stop using UUIDs
      def set_uuid
        self.uuid = Digest::SHA2.hexdigest("#{self.id}#{Time.now.to_s}")
      end      
    end
  end
end