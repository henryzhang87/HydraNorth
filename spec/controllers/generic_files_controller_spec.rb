require 'spec_helper'

describe GenericFilesController, type: :controller do
  let (:dit) { FactoryGirl.create(:dit) }
  before do
    allow(controller).to receive(:has_access?).and_return(true)
    sign_in dit 
    allow_any_instance_of(User).to receive(:groups).and_return([])
    allow_any_instance_of(GenericFile).to receive(:characterize)
  end
  
  describe "#create" do
    context "when uploading a computing science technical report" do
      
      let(:mock) { GenericFile.new(id: 'report_cstr_1234') }
      let(:batch) { Batch.create }
      let(:batch_id) { batch.id }
      let(:file) { fixture_file_upload('/report.pdf','application/pdf') }

      before do
        allow(GenericFile).to receive(:new).and_return(mock)
      end

      it "should record resource type" do
        file = fixture_file_upload('/report.pdf','application/pdf')

        xhr :post, :create, files: [file], Filename: 'CSTR Test', batch_id: batch_id, resource_type: ["Computing Science Technical Report"], terms_of_service: '1'
        saved_file = GenericFile.find('report_cstr_1234')
        expect(saved_file.resource_type).to include "Computing Science Technical Report"
        expect(saved_file.to_solr['resource_type_tesim']).to eq ['Computing Science Technical Report']
      end

    end
  end

  describe "#edit" do
    let(:generic_file) do
      GenericFile.create do |gf|
        gf.apply_depositor_metadata(dit)
        gf.resource_type = ["Computing Science Technical Report"]
      end
    end

    it "should set correct presenter" do
      get :edit, id: generic_file

      expect(response).to be_success
      expect(assigns[:generic_file]).to eq generic_file
      expect(assigns[:form]).to be_kind_of Hydranorth::Forms::CstrEditForm
      expect(response).to render_template(:edit)
    end
  end

end
