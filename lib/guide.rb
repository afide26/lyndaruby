require 'restaurant'
require 'support/string_extend'

class Guide

  class Config
    @@actions = ['list', 'find', 'add', 'quit']

    def self.actions; @@actions; end
  end

  def initialize(path=nil)
    # locate the restaurant text file at path
    Restaurant.filepath = path
    # Check if the restaurant file exists
    if Restaurant.file_usable?
      puts "Found restaurant file."
    # or create a new file
    elsif Restaurant.create_file
      puts "Created restaurant file."
    # exit if create fails
    else
      puts "Exiting....\n\n"
      exit!
    end
  end

  def launch!
    introduction
    result = nil
    # Loop through the list and repeat until user quits
    until result == :quit
      action,args = get_action
      result = do_action(action,args)
    end
    conclusion
  end

  def get_action
    action = nil
    # Keep asking for user input unitl we get a valid action
    until Guide::Config.actions.include?(action)
      puts "Valid actions are: " + Guide::Config.actions.join(", ")
      print "> "
      user_response = gets.chomp
      # Convert the input into an array using split
      args = user_response.downcase.strip.split(' ')
      action = args.shift #same as args[0]
    end
    return [action, args]
  end

  def do_action(action,args=[])
    case action
    when 'list'
      list(args)
    when 'find'
      keyword = args.shift
      find(keyword)
    when 'add'
      add
    when 'quit'
      :quit
    else
      puts "\n I don't understand that command."
    end
  end

  def find(keyword="")
    output_action_header("Finding Restaurant")

    if keyword
      restaurants = Restaurant.saved_restaurants
      found = restaurants.select do |rest|
        rest.name.downcase.include?(keyword.downcase) ||
        rest.cuisine.downcase.include?(keyword.downcase) ||
        rest.price.to_i <= keyword.to_i
      end
      output_restaurant_table(found)
    else
      puts "Find using a key phrase to search the restaurant list"
      puts "Examples: 'find tamale', 'find Mexican', 'find mex' "
    end
  end

  def add
    output_action_header("Add a restaurant")
    restaurant = Restaurant.build_using_questions
    if restaurant.save
      puts "\n#{restaurant.name} saved!\n\n"
    else
      puts "\nSave Error: Restaurant not saved!\n\n"
    end
  end

  def list(args=[])
    sort_order = args.shift
    sort_order = args.shift if sort_order == 'by'
    sort_order = "name" unless ["name", "cuisine", "price"].include?(sort_order)

    output_action_header("Listing Restaurants")

    restaurants = Restaurant.saved_restaurants

    restaurants.sort! do |r1, r2|
      case sort_order
      when 'name'
        r1.name.downcase <=> r2.name.downcase
      when 'cuisine'
        r1.cuisine.downcase <=> r2.cuisine.downcase
      when 'price'
        r1.price.to_i <=> r2.price.to_i
      end
    end
    output_restaurant_table(restaurants)
    puts "Sort using: 'list cuisine' or 'list by cuisine' \n\n"
  end

  def introduction
    puts "\n\n==== Welcome to the Food Finder ====\n\n"
    puts "This is an interactive guide to help you find the food that you crave.\n\n"
  end

  def conclusion
    # User friendly prompt once the user is done
    puts "\n==== Thank you for using the Food Finder and enjoy your meal! ====\n\n\n"
  end
  private

    def output_action_header(text)
      puts "\n#{text.upcase.center(60)}"
      puts "=" * 60 + "\n"
    end

    def output_restaurant_table(restaurants=[])
      print " " + "Name".ljust(30)
      print " " + "Cuisine".ljust(20)
      print " " + "Price".rjust(6)+ "\n"
      puts  "=" * 60

      restaurants.each do |rest|
        line = " " << rest.name.titleize.ljust(30)
        line << " " + rest.cuisine.titleize.ljust(20)
        line << " " + rest.formatted_price.rjust(6)
        puts line
      end
      puts "No listings found" if restaurants.empty?
      puts "=" * 60
    end
end







