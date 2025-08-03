# == Schema Information
#
# Table name: properties
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Property, type: :model do
  describe "associations" do
    it { is_expected.to have_many_attached(:photos) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }

    context "minimum photos (>= 3)" do
      let(:property) { described_class.new(name: "Casa") }

      it "is invalid with 0 photos" do
        expect(property).to be_invalid
        expect(property.errors[:photos]).to include(/mínimo 3/i)
      end

      it "is invalid with 2 photos" do
        property.photos.attach(file_fixture_image("img1.jpg"))
        property.photos.attach(file_fixture_image("img2.jpg"))
        property.valid?
        expect(property.errors[:photos]).to include(/mínimo 3/i)
      end

      it "is valid with 3 photos" do
        property.photos.attach(file_fixture_image("img1.jpg"))
        property.photos.attach(file_fixture_image("img2.jpg"))
        property.photos.attach(file_fixture_image("img1.jpg"))
        expect(property).to be_valid
      end
    end
  end

  describe "#cover_photo" do
    subject(:cover) { property.cover_photo }

    let(:property) do
      p = described_class.new(name: "Cobertura")
      p.save!(validate: false)
      p
    end

    context "when fewer than 3 photos" do
      it "returns nil with 0 photos" do
        expect(cover).to be_nil
      end

      it "returns nil with 2 photos" do
        property.photos.attach(file_fixture_image("img1.jpg"))
        property.photos.attach(file_fixture_image("img2.jpg"))
        expect(property.cover_photo).to be_nil
      end
    end

    context "when 3 or more photos" do
      before do
        property.photos.attach(file_fixture_image("img1.jpg"))
        property.photos.attach(file_fixture_image("img2.jpg"))
        property.photos.attach(file_fixture_image("img1.jpg"))
      end

      it "returns the 3rd photo (index 2) as cover" do
        expect(cover).to eq(property.photos[2])
      end

      it "remains the 3rd as cover even after adding more photos" do
        property.photos.attach(file_fixture_image("img1.jpg"))
        expect(property.cover_photo).to eq(property.photos[2])
      end
    end
  end
end
