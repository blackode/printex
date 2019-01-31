defmodule Printex do
  alias IO.ANSI, as: Ansi

  @moduledoc """
  Documentation for Printex
  --------------------------
  Printex helps you to print the data and strings in color text and color backgrounds. It make use of the `IO.ANSI` Module.

  ## Why Printex ?
  This module prints the different console outputs with different colors and background colors as well.        

  ## Idea
  We can see a lot of lines with regular text in your console at the time of development. It will be hard to identify any of your `IO.inspect` statements output in your console. I thought, it would be nice to highlight our `inspect` statements outputs to distinguish from the regular lines already present in the console.       

  It gives you the direct focus on the console by highlighting text with colors and backgrounds.           

  You can use this in multiple ways like printing the `:error` message and many formats as well.
  This helps you to identify the message from the regular out put of the console. 
  You can also specify the `:bg_color` - Background color for the text to lay on.              

  For more examples and screen shots and how to usage check the [github](https://github.com/blackode/printex)              

  ### NOTE
  > Colors may vary from terminal to terminal...       

  """
  @doc """
  This function puts the `string` accordingly to the given params. The first argument should be the `binary`.    
  The second parameter is the foreground color that you what the string to be print, and the third parameter is the        
  background color used for printing the `string`. However, passing colors are optional.         

  The colors are to be of type `atom` and at present these `[:black,:blue,:cyan,:green,:magenta,:red,:white,:yellow]`  are supported.
  However, it is optional.    

  If the no parameter is passed then default format for printing i.e regular format `IO.puts` is used.


  ## Examples

      iex> Printex.prints("message")
      This prints the message in default color `white`

      iex> Printex.prints("message",:red)
      This prints the message in red color

      iex> Printex.prints {"message",:red}
      This prints the message in  red color

      iex> Printex.prints (%{string: "message",color: :red})
      This prints the message in  red color

      iex> Printex.prints ("message", :red,:white)
      This prints the message in red color with white background          


  ### Text with foreground color                   
  ![Prints Image](assets/images/prints.png)             

  ### Text with background colors                 
  ![Prints Image](assets/images/prints_bg.png)

  """
  def prints({string, color}) do
    _prints(string, color)
  end

  def prints(%{string: string, color: color}) do
    _prints(string, color)
  end

  def prints(string, color \\ :white) do
    _prints(string, color)
  end

  def prints(string, color, bg_color) do
    if color_check?(color) do
      if color_check?(bg_color) do
        ansi_bgformat(color, bg_color, string)
      else
        print_error("bg_color.t is not matched")
        print_info("[:black,:blue,:cyan,:green,:magenta,:red,:white,:yellow]")
      end
    else
      print_error("color.t is not matched")
      print_info("[:black,:blue,:cyan,:green,:magenta,:red,:white,:yellow]")
    end
  end

  #################
  ## print_error ##
  #################

  @doc """

  Prints the given message in the error format. It uses `:red` as a foreground text color.        

  ## Examples

      iex> Printex.print_error "This is error"

  ### Printing Error Text
  ![Prints Image](assets/images/print_error.png)          
  """

  def print_error(string) when is_binary(string) do
    ansi_format(:red, string, "ERROR", "error_message")
    |> IO.puts()
  end

  #################
  ## print_info  ##
  #################

  @doc """
  Prints the given message in the information format in the green color.           


  ## Examples

      iex> Printex.print_info "This is info"

  ### Printing Information Text
  ![Prints Image](assets/images/print_info.png)          
  """

  def print_info(string) when is_binary(string) do
    ansi_format(:green, string, "INFO", "info_message")
    |> IO.puts()
  end

  #################
  # print_warning #
  #################

  @doc """
  Prints the given message in the warning format in the yellow color.       

  ## Examples

      iex> Printex.print_warning "This is warning"            

  ### Printing Warning Text
  ![Prints Image](assets/images/print_warning.png)          
  """
  def print_warning(string) when is_binary(string) do
    ansi_format(:yellow, string, "WARNING", "warn_message")
    |> IO.puts()
  end

  @doc """
  This prints the given text in the format you specified. The string formats are 
  as follows
  :x_on_y here {x,y} can be any 8 possible colors

  1. black
  2. blue
  3. cyan
  4. green
  5. magenta
  6. red
  7. white
  8. yellow     

  In addition you can also specify respective light combination of colors

  ## Usage 
  `:black_on_white`    
  prints the text in black color with white background.            
  `:red_on_light_green`          
  prints the text in red color with light_green background.           
  `:light_blue_on_light_cyan`             
  prints the text in light_blue color with light_cyan background.          

  ### x_on_y format colors
  ![x_on_y image](assets/images/x_on_y.png)
  """
  @spec color_print(binary, atom) :: list

  def color_print(string, format) when is_binary(string) and is_atom(format) do
    [color, bg_color] = parse_colors(format)
    prints(string, String.to_atom(color), String.to_atom(bg_color))
  end

  ##########
  #  print #
  ##########

  @doc """
  Prints the given data with the label provided.If the label is not provided
  label data is used. How ever you can say not to use the label by passing `:no_label`
  option

  ## Examples
      print("print with out label",:no_label)
      print("Normal Print")
      print([1,2,3])
  ## Usage
  You can use this function in three different ways.
  1. Using the default label format.`print("hello")`
  2. With out any label text. `print("hello",:no_label)`
  3. Passing label option as string. `print("hello","greeting")` here the text greeting is treated as :label
  3.1 Passing label option as list. `print("hello",label: "greeting")`

  ### print function
  ![print image](assets/images/print.png)
  """
  def print(data, label \\ :default) do
    case label do
      :default ->
        IO.inspect(data,
          label: """
             --------
             # data #
             --------
          """
        )

      :no_label ->
        IO.inspect(data)

      label when is_binary(label) ->
        IO.inspect(data,
          label: """
           ---------------
           #{label}
           ---------------
          """
        )

      label when is_list(label) ->
        IO.inspect(data, label)

      _ ->
        print_error("No Matching clause found")
    end
  end

  ####################################
  #         Private Definitions      # 
  ####################################

  defp parse_colors(atom) when is_atom(atom) do
    atom
    |> Atom.to_string()
    |> String.split(~r{_on_})
  end

  defp ansi_bgformat(color, bg_color, string) do
    IO.puts(ansi_bgcolor(bg_color) <> ansi_color(color) <> string <> Ansi.reset())
  end

  defp ansi_format(color, string, type, type_message) do
    Ansi.format(
      [
        color,
        """
        <<<<<<<<<<<<<<<<
            #{type}   
        >>>>>>>>>>>>>>>>

        -------------------------
        #{type_message}: #{string}
        -------------------------
        """
      ],
      true
    )
  end

  defp _prints(string, color) do
    [color, string]
    |> params_validation
    |> Ansi.format(true)
    |> IO.puts()
  end

  defp params_validation([color, string]) do
    if is_atom(color) do
      if is_binary(string) do
        case color_check?(color) do
          false ->
            [
              :red,
              ":error,:color_value color_value ond of[:black,:blue,:cyan,:green,:magenta,:red,:white,:yellow]"
            ]

          true ->
            [color, string]
        end
      else
        [:red, ":error,:type String.t should be the :binary"]
      end
    else
      [:red, ":error,:type color.t should be the :atom"]
    end
  end

  defp color_check?(color) do
    colors = [
      :black,
      :blue,
      :cyan,
      :green,
      :magenta,
      :red,
      :white,
      :yellow,
      :light_black,
      :light_blue,
      :light_cyan,
      :light_green,
      :light_magenta,
      :light_red,
      :light_white,
      :light_yellow
    ]

    Enum.any?(colors, fn kolor -> kolor == color end)
  end

  defp ansi_color(color) when is_atom(color) do
    if color_check?(color),
      do: apply(Ansi, color, []),
      else: print_error("color did not matched")
  end

  defp ansi_bgcolor(color) when is_atom(color) do
    if color_check?(color) do
      apply(Ansi, String.to_atom("#{color}_background"), [])
    else
      print_error("color did not matched")
    end
  end
end
