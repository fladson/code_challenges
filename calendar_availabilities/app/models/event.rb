# Assumptions
# - Event ends_at day cannot be different from the starts_at day.
# - I would create separate services to distribute the responsabilities but the
#     instructions are saying to stick with the model.

class Event < ApplicationRecord
  AVAILABILITY_RANGE = 6
  # for recurring shifting
  validates_uniqueness_of :weekly_recurring, scope: %i[kind starts_at ends_at]

  scope :recurring_openings, -> { where(kind: 'opening', weekly_recurring: true) }
  scope :grouped_events_in_range_for, -> (kind, date) do
    where(
      kind: kind,
      starts_at: date..date.advance(days: AVAILABILITY_RANGE)
    ).group_by{ |e| e.starts_at.to_date }
  end

  class << self
    def availabilities(date)
      raise TypeError unless date.is_a?(DateTime)
      openings = openings_from(date)
      appointments = appointments_from(date)

      openings.each.with_index do |opening, i|
        opening[:slots] = opening[:slots] - appointments[i][:slots]
      end
    end

    private

    def openings_from(date)
      shift_recurring_openings_to!(date) # IMPORTANT - this has to be before
      openings = grouped_events_in_range_for('opening', date)

      calculate_availabilities(openings, date)
    end

    def appointments_from(date)
      appointments = grouped_events_in_range_for('appointment', date)

      calculate_availabilities(appointments, date)
    end

    def shift_recurring_openings_to!(date)
      recurring_openings.each do |opening|
        return unless date > opening.starts_at

        weeks_to_advance = opening.starts_at.to_date.step(date, 7).count
        Event.create(
          kind: 'opening',
          starts_at: opening.starts_at.advance(weeks: weeks_to_advance),
          ends_at: opening.ends_at.advance(weeks: weeks_to_advance),
          weekly_recurring: true
        )
      end
    end

    def calculate_availabilities(collection, date)
      range_from(date).each.with_object([]) do |day, array|
        array << calculate_availability_for(collection, day)
      end
    end

    def calculate_availability_for(collection, date)
      return new_availability(date) if collection[date].blank?

      availability = new_availability(date)
      collection[date].each do |event|
        availability[:slots] << (event.starts_at.to_i...event.ends_at.to_i)
        .step(30.minutes)
        .each
        .with_object([]) { |slot, array| array << slot }
      end
      availability[:slots] = availability[:slots]
        .flatten
        .uniq
        .sort
        .map { |slot| Time.at(slot).utc.to_formatted_s(:short) }

      availability
    end

    def new_availability(date)
      {
        date: date.to_date.to_s,
        slots: []
      }
    end

    def range_from(date)
      date..date.advance(days: AVAILABILITY_RANGE)
    end
  end
end
