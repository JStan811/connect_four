# connect_four

This repo is for the Connect Four project from [The Odin Project](https://www.theodinproject.com/paths/full-stack-ruby-on-rails/courses/ruby-programming/lessons/connect-four).

The goal of this project is to learn TDD using Rspec. This is the first project I've approached using TDD.

Thoughts:
TDD adds what feels like a lot of work to programming. But I can see its usefulness. First, it was nice to not have to test my program by calling the scripts countless times on the command line or having to add 'puts's and 'p's all over my code to figure out where things are going wrong only to remove them them later. Also, it seems that my methods came out much cleaner using TDD than they have in my past projects. Writing the tests made it clearer how each method should act and if a method was doing too much. I feel I caught on much quicker to methods that would be problematic and refactored them sooner using TDD. One example of this is my Game#game_loop. The game loops I've written in the past have all been large monsters doing way too many things. The one for this project ended up being only 8 lines. Writing the tests for it help me see that it was growing too big and how to best split it up. Finally, using TDD helped me understand how to build methods better. The assignment prior to this project, I had to complete the lessons in [this repo](https://github.com/TheOdinProject/ruby_testing). It contains a file, '15a_binary_game_spec.rb', that discusses different types of methods (Command, Query, Script, and Looping Script). While I was writing tests on Connect Four, I tried to approach my method design with this framework in mind and it really helped with deciding how each method should act.

Overall, I'm pretty happy with this project! I feel I learned a lot about TDD and how to use Rspec. Rspec felt like a completely new language at first but I think I have a solid grasp of it now.
