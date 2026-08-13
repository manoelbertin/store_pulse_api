RSpec.shared_examples "like searchable concern" do |factory_name, field|
  let!(:search_param) { "termo_unico" }
  let!(:record) { create(factory_name, field => "Registro com termo_unico") }
  let!(:other_record) { create(factory_name, field => "Diferente") }

  it "filtra os registros pelo campo e termo buscados" do
    found_records = described_class.like(field, search_param)
    expect(found_records).to include(record)
    expect(found_records).not_to include(other_record)
  end
end
