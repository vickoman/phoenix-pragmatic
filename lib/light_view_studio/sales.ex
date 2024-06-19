defmodule LightViewStudio.Sales do
  def new_orders do
    Enum.random(5..20)
  end

  def sales_mount do
    Enum.random(1000..5000)
  end

  def satisfaction do
    Enum.random(0..100)
  end
end
