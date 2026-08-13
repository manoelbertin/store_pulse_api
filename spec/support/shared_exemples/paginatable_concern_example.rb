RSpec.shared_examples "paginatable concern" do |factory_name|
  context "quando a paginação é aplicada" do
    let!(:records) { create_list(factory_name, 15) }

    it "retorna a quantidade correta de registros por página" do
      paginated_records = described_class.paginate(1, 10)
      expect(paginated_records.count).to eq(10)
    end

    it "retorna os registros da página solicitada" do
      paginated_records = described_class.paginate(2, 10)
      expect(paginated_records.count).to eq(5)
    end
  end
end
