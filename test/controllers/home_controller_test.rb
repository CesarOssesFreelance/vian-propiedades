require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end
  test "hero prioritizes featured properties then fills with newest normal properties" do
    Propiedad.update_all(publicada: false)
    featured = 3.times.map { |i| create_hero_property(destacada: true, created_at: (20 - i).days.ago) }
    normal = 9.times.map { |i| create_hero_property(destacada: false, created_at: (10 - i).days.ago) }
    create_hero_property(destacada: true, publicada: false, created_at: Time.current)

    assert_hero_order(featured.reverse + normal.reverse.first(7))
  end

  test "hero limits featured properties to the ten newest" do
    Propiedad.update_all(publicada: false)
    featured = 12.times.map { |i| create_hero_property(destacada: true, created_at: (20 - i).days.ago) }
    create_hero_property(destacada: false, created_at: Time.current)

    assert_hero_order(featured.reverse.first(10))
  end

  test "hero shows fewer than ten when there are not enough published properties" do
    Propiedad.update_all(publicada: false)
    older = create_hero_property(created_at: 2.days.ago)
    newer = create_hero_property(created_at: 1.day.ago)

    assert_hero_order([newer, older])
  end

  test "hero retains fallback when there are no published properties" do
    Propiedad.update_all(publicada: false)
    get root_url
    assert_response :success
    assert_select "a.vian-hero-slide", count: 0
    assert_select "img.vian-hero-slide.is-active", count: 1
    assert_select ".vian-hero-controls", count: 0
  end

  test "featured cards fill nine slots and show transaction and featured badges" do
    Propiedad.update_all(publicada: false)
    featured = 2.times.map { |i| create_hero_property(destacada: true, tipo_transaccion: :arriendo, created_at: (20 - i).days.ago) }
    normal = 10.times.map { |i| create_hero_property(created_at: (12 - i).days.ago) }
    create_hero_property(destacada: true, publicada: false)

    get root_url
    assert_response :success
    assert_card_order(featured.reverse + normal.reverse.first(7))
    assert_select ".property-entry .offer-type.bg-primary", text: "Destacada", count: 2
    assert_select ".property-entry .offer-type.bg-success", text: "Arriendo", count: 2
    assert_select ".property-entry .offer-type.bg-success", text: "Venta", count: 7
  end

  test "featured cards include only nine newest featured when there are enough" do
    Propiedad.update_all(publicada: false)
    featured = 11.times.map { |i| create_hero_property(destacada: true, created_at: (20 - i).days.ago) }
    create_hero_property

    get root_url
    assert_card_order(featured.reverse.first(9))
    assert_select ".property-entry .offer-type.bg-primary", count: 9
  end

  test "featured cards show available normal properties without featured badges" do
    Propiedad.update_all(publicada: false)
    property = create_hero_property

    get root_url
    assert_card_order([property])
    assert_select ".property-entry .offer-type.bg-primary", count: 0
  end

  test "home search offers all sale and rental transaction options" do
    get root_url
    assert_response :success
    assert_select "form[action=?]", propiedades_path do
      assert_select "select[name=tipo_transaccion]" do
        assert_select "option[value='']", text: "Todas"
        assert_select "option[value=venta]", text: "Venta"
        assert_select "option[value=arriendo]", text: "Arriendo"
      end
    end
  end

  private

  def assert_card_order(properties)
    assert_select ".property-entry .property-title a" do |links|
      assert_equal properties.map { |property| propiedad_path(property) }, links.map { |link| link["href"] }
    end
  end

  def create_hero_property(**attributes)
    Propiedad.create!({
      titulo: "Propiedad del carrusel", precio: 100_000_000, comuna: comunas(:one),
      tipo_inmueble: :casa, tipo_transaccion: :venta, publicada: true, destacada: false
    }.merge(attributes))
  end

  def assert_hero_order(properties)
    get root_url
    assert_response :success
    assert_select "a.vian-hero-slide" do |slides|
      assert_equal properties.map { |property| propiedad_path(property) }, slides.map { |slide| slide["href"] }
    end
    assert_select ".vian-hero-indicator", count: properties.size
  end
end
