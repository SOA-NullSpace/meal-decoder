# frozen_string_literal: true

require_relative '../../../helpers/spec_helper'
require_relative '../../../helpers/vcr_helper'

describe 'Test DetectMenuText service' do
  VcrHelper.setup_vcr

  before do
    @config = OpenStruct.new(
      OPENAI_API_KEY: OPENAI_API_KEY,
      GOOGLE_CLOUD_API_TOKEN: GOOGLE_CLOUD_API_TOKEN
    )
    VcrHelper.configure_vcr_for_apis(@config)
  end

  after do
    VcrHelper.eject_vcr
  end

  it 'HAPPY: should detect text from valid image' do
    VCR.use_cassette('service_detect_menu_text') do
      image_path = File.join(__dir__, '../../../fixtures/text_menu_img.jpeg')
      image_file = {
        tempfile: File.new(image_path),
        type: 'image/jpeg',
        filename: 'text_menu_img.jpeg'
      }

      result = MealDecoder::Services::DetectMenuText.new.call(image_file)

      _(result).must_be_kind_of Dry::Monads::Success
      _(result.value!).wont_be_empty
    end
  end

  it 'SAD: should return Failure for invalid file' do
    result = MealDecoder::Services::DetectMenuText.new.call(
      tempfile: 'nonexistent.jpg',
      type: 'image/jpeg',
      filename: 'nonexistent.jpg'
    )

    _(result).must_be_kind_of Dry::Monads::Failure
    _(result.failure).must_include 'Text detection error'
  end
end
