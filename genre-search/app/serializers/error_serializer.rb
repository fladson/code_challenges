class ErrorSerializer < ApplicationSerializer
  def as_json(*)
    {
      errorCode: object['code'],
      message: object['message']
    }
  end
end
