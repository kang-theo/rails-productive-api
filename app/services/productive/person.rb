# frozen_string_literal: true

module Productive
  class Person < Base
    include Parser

    def organizations
      associative_query(Organization, organization_id)
    end

    def subsidiaries
      associative_query(Subsidiary, subsidiary_id)
    end

    def holiday_calendars
      associative_query(HolidayCalendar, holiday_calendar_id)
    end

    private

    def associative_query(klass, ids)
      ids.map { |id| klass.find(id) }
    end
  end
end