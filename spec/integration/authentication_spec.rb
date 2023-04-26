require 'swagger_helper'

describe 'Authentication API' do
  before do
    # Do nothing
  end

  after do
    # Do nothing
  end

  path '/api/v1/customers/auth' do
    post 'Sign up as a customer' do
      tags 'Customers'
      consumes 'application/json'
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          first_name: { type: :string },
          last_name: { type: :string },
          email: { type: :string },
          password: { type: :string },
          password_confirmation: { type: :string },
          username: { type: :string }
        },
        required: %w[email password password_confirmation]
      }

      response '200', 'Customer created' do
        let(:customer) { { email: 'test@test.com', password: 'password', password_confirmation: 'password_confirmation' } }
        run_test!
      end

      response '422', 'Invalid request' do
        let(:customer) { { email: 'test@test.com' } }
        run_test!
      end
    end
  end

  path '/api/v1/customers/auth/sign_in' do
    post "Sign in customer" do
      tags 'Customers'
      consumes 'application/json'
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
        },
        required: %w[email password password_confirmation]
      }

      response '200', 'Customer signed in' do
        let(:customer) { { email: 'test@test.com', password: 'password' } }
        header 'authorization', schema: { type: :string }, description: 'Bearer authentication header'
        run_test!
      end

      response '401', 'Invalid request' do
        let(:customer) { { email: 'test@test.com' } }
        run_test!
      end
    end
  end

  path '/api/v1/customers/auth/sign_out' do
    delete "Sign out customer" do
      tags 'Customers'
      consumes 'application/json'
      parameter name: :customer, in: :body, schema: {
        type: :object,
        properties: {
          email: { type: :string },
          password: { type: :string },
        },
        required: %w[email password password_confirmation]
      }

      response '200', 'Customer signed in' do
        let(:customer) { { email: 'test@test.com', password: 'password' } }
        run_test!
      end

      response '401', 'Invalid request' do
        let(:customer) { { email: 'test@test.com' } }
        run_test!
      end
    end
  end
end
