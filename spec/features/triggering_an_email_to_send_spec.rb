require 'spec_helper'

describe 'when a trigger email exists' do
  it 'find the appropriate email and then trigger it to send' do
    emails = EmailCenterApi::Trees::Node.emails(folder: 123)

    email = emails.detect { |e| e.name == 'Test Email' }

    email_address = 'test@reevoo.com'
    options = {
      'Reviews' => {
        'retailer_product_name' => 'Test product',
        'retailer_name' => 'test retailer',
        'retailer_from' => 'reply@reevoo.com'
      }
    }
    expect(
      email.trigger(email_address, options).response.code
    ).to eq('200')
  end

end
