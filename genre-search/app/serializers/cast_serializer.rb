class CastSerializer < ApplicationSerializer
  GENDERS = {
    1 => 'Female',
    2 => 'Male'
  }.freeze
  private_constant :GENDERS

  def as_json(*)
    {
      id: object['id'],
      gender: GENDERS[object['gender']],
      name: object['name'],
      profilePath: object['profilePath']
    }
  end
end
