defmodule Printex do
  alias IO.ANSI,as: Ansi

  @moduledoc """
  Documentation for Printex.
  --------------------------
  Printex Module helps you to print the data and strings in color format in console.
  You use in multiple ways like printing the :error message and many formats.
  
  This helps you identify message from the regular out put of the console. 
  You can also specify the :bgcolor - Background color for the text to lay on.

  """
  @doc """
  This function prints the string passed in the color you specified or else it uses 
  the default format for printing i.e regulat format IO.puts 

  ## Examples

      iex> Printex.prints("message")
      "message"
      :ok
      iex> Printex.prints("message",:red)
      "message"
      :ok
      iex> Printex.prints {"message",:red}
      "message"
      :ok
      iex> Printex.prints (string: "message",color: :red)
      "message"
      :ok
  """
  def prints({string,color}) do
    _prints(string,color)
  end

  def prints (%{string: string, color: color \\ :default}) do
    _prints(string,color)
  end
  
  def prints(string,color \\:default) do
    _prints(string,color)
  end

  defp _prints(string,color) do
    [color,string]
    |> params_validation
    |> Ansi.format(true)
    |> IO.puts
  end

  defp params_validation [color,string]do
    if is_atom(color) do
      if is_string(string) do
        [color,string]
      else
        [:red,":error,:type String.t should be the :binary"]
      end
    else 
        [:red,":error,:type color.t should be the :atom"]
    end
  end
end
