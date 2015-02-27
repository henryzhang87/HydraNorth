require 'spec_helper'

describe GenericFilesController, :type => :controller do
  let(:user) { FactoryGirl.find_or_create(:jill) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in user
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow(controller).to receive(:clear_session_user)
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end

  describe "#create" do
    context "when uploading a file" do
      let(:mock) { GenericFile.new(id: '123') }
      let(:batch) { Batch.create }
      let(:batch_id) { batch.id }
      let(:file) { fixture_file_upload('/report.pdf','application/pdf') }
      before do
        allow(GenericFile).to receive(:new).and_return(mock)
      end

      it "should record resource type" do
        file = fixture_file_upload('/report.pdf','application/pdf')
        
        xhr :post, :create, files: [file], Filename: 'CSTR Test', batch_id: batch_id, resource_type: ["Computing Science Technical Report"], terms_of_service: '1'
        saved_file = GenericFile.find('123')
        expect(saved_file.resource_type).to include "Computing Science Technical Report" 
      end

    end
  end

end
