require 'spec_helper'

describe Hydranorth::CstrPresenter do
  describe "#terms" do
    it "should return a list" do
      expect(described_class.terms).to eq([:resource_type, :title, :creator, :contributor, :trid, :description, :tag, :temporal, :spatial, :date_created, :rights, :subject, :related_url])
    end
  end
end
