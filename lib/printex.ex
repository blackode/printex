defmodule Printex do
  alias IO.ANSI, as: Ansi

  @moduledoc """
  Documentation for Printex
  --------------------------
  Printex helps you to print the data and strings in color text and color 
  backgrounds. It make use of the `IO.ANSI` Module.

  ## Why Printex ?
  This module prints the different console outputs with different colors and 
  background colors as well.        

  ## Idea
  We can see a lot of lines with regular text in your console at the time of 
  development. It will be hard to identify any of your `IO.inspect` statements 
  output in your console. I thought, it would be nice to highlight our `inspect` 
  statements outputs to distinguish from the regular lines already present 
  in the console.       

  It gives you the direct focus on the console by highlighting text with 
  colors and backgrounds.           

  You can use this in multiple ways like printing the `:error` message and 
  many formats as well.

  This helps you to identify the message from the regular out put of the console. 
  You can also specify the `:bg_color` - Background color for the text to lay on.              

  For more examples and screen shots and how to usage 
  check the [github](https://github.com/blackode/printex)              

  ### NOTE
  > Colors may vary from terminal to terminal...       

  """
  @doc """
  This function puts the `string` accordingly to the given params. The first 
  argument should be the `binary`.    
  The second parameter is the foreground color that you what the string to be 
  print, and the third parameter is the background color used for printing the 
  `string`. However, passing colors are optional.

  The colors are to be of type `atom` and at present the following colors have
  been supported

  ```
  [:black,:blue,:cyan,:green,:magenta,:red,:white,:yellow]`
  ```
  However, it is optional to pass the color. By default it uses `yellow` 
  background with `black` foreground


  ## Examples

      iex> Printex.prints("message")
      This FG Color `yellow` & BG Color 'black',

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

  def prints(string, color \\ :yellow) do
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
  `:red_on_light_green`          white
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
      print("print with out label", :no_label)
      print("I Print with Deafault label DATA")
      print([1,2,3])
      print("I print with Label", "Your Label Here")
  ## Usage
  You can use this function in three different ways.
  1. Using the default label format.`print("hello")`
  2. With out any label text. `print("hello",:no_label)`
  3. Passing label option as string. `print("hello","greeting")`
     here the text greeting is treated as :label
     3.1 Passing label option as list. `print("hello",label: "greeting")`

  ### print function
  ![print image](assets/images/print.png)
  """
  def print(data, label \\ :default) do
    case label do
      :default ->
        _print(data, "DATA")

      :no_label ->
        IO.inspect(data)

      label when is_binary(label) ->
        _print(data, label)

      label when is_list(label) ->
        label_string = Keyword.get(label, :label)
        _print(data, label_string)

      _ ->
        print_error("No Matching clause found")
    end
  end

  @doc """
  This function helps to print a map with optons.

  You an either print whole map or specific keys  in a map.

  The options here is a `Keyword` with following keys

  ## Options
  * `keys` - list of keys to be print
  * `label` - A string label for the display
  * `isolate` - It is default `false` and if you pass as `true`, each key gets 
     printed


  ## Examples 

      iex> Printex.print(map)
      This prints the whole map

      iex> Printex.print_map(%{name: "hell", age: "hello"}, keys: [:name])
      This just prints the name

      iex> Printex.print_map(%{name: "hell", age: "hello"}, isolate: true)
      This prints each key in map separately

  ### print_map function
  ![print image](assets/images/print_map.png)
  """
  def print_map(map, options \\ []) do
    keys = Keyword.get(options, :keys) || :all
    isolate = Keyword.get(options, :isolate) || false
    label = Keyword.get(options, :label) || "DATA"

    case {keys, isolate} do
      {:all, false} ->
        print(map, label)

      {:all, true} ->
        keys = Map.keys(map)
        print_individual_map_keys(map, keys)

      {keys, false} when is_list(keys) ->
        map = Map.take(map, keys)
        print(map, label)

      {keys, true} when is_list(keys) ->
        print_individual_map_keys(map, keys)
    end
  end

  @doc """
  This helps to print the list with number of units we need.

  We can pass specific style text like in the following way

  * `first_<num>` ex `first_3` to print the first 3 elements in a list given.
  * `last_<num>` ex `last_5` to print the last 5 elements in a list provided
  * `first_<num>_last_<num>` ex `first_3_last_5` to print the first 3 elements 
     and last 5 elements in a list

  You can also pass just an integer like `3`  and `-3` the `-` specifies the 
  direction for printing of elements in a list.

  ## Examples

      iex> list = ~w(1 2 3 4 5 6 7 8 9 10)
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]

      iex> print_list list
      -------- DATA BEGIN -------
      ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
      -------- DATA ENDS --------

      iex> print_list list, :first_3
      -------- DATA BEGIN -------
      ["1", "2", "3"]
      -------- DATA ENDS --------

      iex> print_list list, :last_5
      -------- DATA BEGIN -------
      ["6", "7", "8", "9", "10"]
      -------- DATA ENDS --------

      iex> print_list list, :first_2_last_3
      -------- DATA BEGIN -------
      ["1", "2", "8", "9", "10"]
      -------- DATA ENDS --------

      iex> print_list list, -5
      -------- DATA BEGIN -------
      ["6", "7", "8", "9", "10"]
      -------- DATA ENDS --------

      iex> print_list list, 3
      -------- DATA BEGIN -------
      ["1", "2", "3"]
      -------- DATA ENDS --------
        
  ### print_list function
  ![print image](assets/images/print_list.png)
  """

  def print_list(list, count_label \\ :all) do
    list =
      case count_label do
        :all ->
          list

        count when is_integer(count) ->
          Enum.take(list, count)

        count_label ->
          label = "#{count_label}"
          get_list_by_count_label(list, label)
      end

    print(list)
  end

  ####################################
  #         Private Definitions      # 
  ####################################

  defp get_list_by_count_label(list, label) do
    case get_count_from_count_label(label) do
      {first, last} when is_integer(first) and is_integer(last) ->
        Enum.take(list, first) ++ Enum.take(list, last)

      count when is_integer(count) ->
        Enum.take(list, count)

      _ ->
        print_error("Invalid Count given to print_list")
        0
    end
  end

  defp get_count_from_count_label(count_label) when is_binary(count_label) do
    label = String.trim(count_label)

    case String.split(label, "_") do
      ["first", value] ->
        String.to_integer(value)

      ["last", value] ->
        value = String.to_integer(value)
        -value

      ["first", first_value, "last", last_value] ->
        first_value = String.to_integer(first_value)
        last_value = String.to_integer(last_value)
        {first_value, -last_value}
    end
  end

  defp print_individual_map_keys(map, keys) do
    map = Map.take(map, keys)

    Enum.each(map, fn {key, value} ->
      print(value, "#{key}")
    end)
  end

  defp _print(data, label) do
    yellow_color = ansi_color(:yellow)
    reset = Ansi.reset()
    IO.puts(yellow_color <> "-------- #{label} BEGIN -------" <> reset)
    IO.inspect(data)
    IO.puts(yellow_color <> "-------- #{label} ENDS --------" <> reset)
  end

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
        ~~~~~~~~~~~~~~~~
        #{type}   
        ~~~~~~~~~~~~~~~~

        -------------- #{type_message} BEGIN -----------
        #{string}
        -------------- #{type_message} END -------------
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
