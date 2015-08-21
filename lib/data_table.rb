class DataTable
  SORT_DIRECTIONS = ['asc', 'desc']

  def initialize(controller, opts = {})
    @controller = controller
    @opts = opts
  end

  def root
    nil
  end

  def columns
    []
  end

  def searchable
    []
  end

  def all_results
    root
  end

  def filtered_results
    results = root

    results = apply_search(results) if search?

    results
  end

  def final_results
    results = filtered_results

    results = apply_order(results) if order?
    results = apply_limit(results) if limit?

    results
  end

  def draw
    params[:draw]
  end

  private def params
    @controller.params
  end

  private def controller
    @controller
  end

  private def opts
    @opts
  end

  private def order?
    params.has_key?(:order)
  end

  private def search?
    search_params = params[:search]
    !searchable.empty? && !search_params.nil? && !search_params[:value].to_s.empty?
  end

  private def limit?
    (params.has_key?(:length) && params[:length].to_i > 0) ||
      (params.has_key?(:start) && params[:start].to_i > 0)
  end

  private def apply_search(query)
    search = "%#{params[:search][:value].downcase}%"

    clauses = []
    searches = []

    searchable.each do |column|
      clauses << "lower(#{column}) LIKE ?"
      searches << search
    end

    query = query.where(clauses.join(' OR '), *searches)

    query
  end

  private def apply_order(query)
    params[:order].each_pair do |_, order_def|
      column = columns[order_def['column'].to_i]
      direction = order_def['dir']

      next if column.nil?
      next if !SORT_DIRECTIONS.include?(direction)

      query = query.order("#{column} #{direction}")
    end

    query
  end

  private def apply_limit(query)
    query = query.offset(params[:start].to_i) if params[:start].to_i > 0
    query = query.limit(params[:length].to_i) if params[:length].to_i > 0

    query
  end
end
