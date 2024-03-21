myfile <- file("inputs/input.txt", open = "r")
lines <- readLines(myfile)
num_rows <- length(lines)
num_cols <- nchar(lines[1])

node_network <- setRefClass("NodeNetwork",
  fields = list(nodes = "list"),
  methods = list(
    add_new_node = function(node_name, node_type, receivers) {
      if (node_type == "b") {
        new_node <- broadcaster$new(
          name = node_name,
          type = node_type,
          receivers = receivers
        )
      } else if (node_type == "%") {
        new_node <- flip_flop$new(
          name = node_name,
          state = low_value,
          type = node_type,
          receivers = receivers
        )
      } else if (node_type == "&") {
        new_node <- nand$new(
          name = node_name,
          memory = list(), # list of (from, value) pairs
          type = node_type,
          receivers = receivers
        )
      }
      nodes <<- c(nodes, new_node)
    },
    get_node = function(name) {
      for (node in nodes) {
        if (node$name == name) {
          return(node)
        }
      }
      return(NULL)
    }
  )
)

node <- setRefClass("Gate",
  fields = list(name = "character",
                type = "character",
                receivers = "list"),
  methods = list(
    get_receiver_nodes = function() {
      receiver_nodes <- c()
      for (receiver in receivers) {
        receiver_node <- network$get_node(receiver)
        receiver_nodes <- c(receiver_nodes, receiver_node)
      }
      return(receiver_nodes)
    }
  )
)

flip_flop <- setRefClass("FlipFlop", "Gate",
  fields = list(state = "numeric"),
  methods = list(
    receive = function(signal) {
      current_state <- state
      new_signals_to_create <- flip_flop_receive(
        state = state,
        receivers = receivers,
        value = signal$value
      )
      if (length(new_signals_to_create) > 1) {
        new_state <- new_signals_to_create[[length(new_signals_to_create)]]
        new_signals_to_create <- new_signals_to_create[
          -length(new_signals_to_create)
        ]
        state <<- new_state
      }
      return(new_signals_to_create)
    }
  )
)

broadcaster <- setRefClass("Broadcaster", "Gate",
  fields = list(),
  methods = list(
    receive = function(signal) {
      new_signals_to_create <- broadcaster_receive(
        receivers = receivers,
        value = signal$value
      )
    }
  )
)

nand <- setRefClass("Nand", "Gate",
  fields = list(memory = "list"),
  methods = list(
    receive = function(signal) {
      new_signals_to_create <- nand_receive(
        from = signal$sender$name,
        value = signal$value,
        memory = memory,
        receivers = receivers
      )
      if (length(new_signals_to_create) > 1) {
        new_memory <- new_signals_to_create[[length(new_signals_to_create)]]
        new_signals_to_create <- new_signals_to_create[
          -length(new_signals_to_create)
        ]
        memory <<- new_memory
      }
      return(new_signals_to_create)
    }
  )
)

signals_manager <- setRefClass("SignalManager",
  fields = list(signals = "list"),
  methods = list(
    create_signal = function(sender, receiver, value) {
      signal <- signal$new(
        sender = sender,
        receiver = receiver,
        value = value
      )
      signals <<- c(signals, signal)
    },
    add_signals_for_sender = function(new_signals_description, sender) {
      for (description in new_signals_description) {
        new_receiver <- network$get_node(description[[1]])
        if (is.null(new_receiver)) {
          network$add_new_node(
            node_name = description[[1]],
            node_type = "b",
            receivers = list()
          )
          new_receiver <- network$get_node(description[[1]])
        }
        new_value <- description[[2]]
        create_signal(sender, new_receiver, new_value)
      }
    },
    consume_next = function() {
      current_signal <- signals[[1]]
      signals <<- signals[-1]
      old_receiver <- current_signal$receiver
      new_signals_description <- current_signal$propagate()
      add_signals_for_sender(new_signals_description, old_receiver)
    }
  )
)

signal <- setRefClass("Signal",
  fields = list(sender = "Gate",
                receiver = "Gate",
                value = "numeric"),
  methods = list(
    propagate = function(.self) {
      new_signals_description <- .self$receiver$receive(.self)
      return(new_signals_description)
    }
  )
)

high_value <- 1
low_value <- 0

high_value_count <- 0
low_value_count <- 0

b_create <- function(receivers, value) {
  to_create <- list()
  for (receiver in receivers) {
    if (value == high_value) {
      high_value_count <<- high_value_count + 1
    } else {
      low_value_count <<- low_value_count + 1
    }
    description <- list(receiver, value)
    to_create <- c(to_create, list(description))
  }
  return(to_create)
}

broadcaster_receive <- function(receivers, value) {
  new_signals_to_create <- b_create(receivers, value)
  return(new_signals_to_create)
}

flip_flop_receive <- function(state, receivers, value) {
  if (value == high_value) {
    return(list())
  }
  new_state <- ifelse(state == high_value, low_value, high_value)
  new_signals_to_create <- b_create(receivers, new_state)
  return(c(new_signals_to_create, new_state))
}

set_nand_memories <- function(network) {
  for (node in network$nodes) {
    for (receiver in node$receivers) {
      receiver_node <- network$get_node(receiver)
      if (is.null(receiver_node)) {
        network$add_new_node(
          node_name = receiver,
          node_type = "b",
          receivers = list()
        )
        receiver_node <- network$get_node(receiver)
      }
      if (receiver_node$type == "&") {
        if (length(receiver_node$memory) == 0) {
          receiver_node$memory <- list(list(node$name, low_value))
        } else {
          receiver_node$memory <- c(
            receiver_node$memory,
            list(list(node$name, low_value))
          )
        }
      }
    }
  }
}

nand_receive <- function(from, value, memory, receivers) {
  for (i in 1:length(memory)) { # nolint: seq_linter.
    if (memory[[i]][1] == from) {
      memory[[i]][2] <- value
      break
    }
  }

  has_all_high <- TRUE
  for (i in 1:length(memory)) { # nolint: seq_linter.
    if (memory[[i]][[2]] == high_value) {
      has_all_high <- TRUE
    } else {
      has_all_high <- FALSE
      break
    }
  }

  new_value <- ifelse(has_all_high, low_value, high_value)
  new_signals_to_create <- b_create(receivers, new_value)
  return(c(new_signals_to_create, list(memory)))
}

network <- node_network$new()
for (i in 1:num_rows) {
  split_line <- trimws(strsplit(lines[i], "->")[[1]])
  node_descr <- split_line[1]
  receivers <- c()
  if (length(split_line) > 1) {
    receivers <- trimws(strsplit(split_line[2], ",")[[1]])
  }
  receivers <- as.list(receivers)
  node_type <- substr(node_descr, 1, 1)
  node_name <- substr(node_descr, 2, nchar(node_descr))
  if (node_type == "b") {
    node_name <- node_descr
  }
  network$add_new_node(
    node_name = node_name,
    node_type = node_type,
    receivers = receivers
  )
}
set_nand_memories(network)

network$add_new_node(
  node_name = "button",
  node_type = "b",
  receivers = list("broadcaster")
)

button <- network$get_node("button")
caster <- network$get_node("broadcaster")

manager <- signals_manager$new()
num_button_presses <- 1000
for (i in 1:num_button_presses) {
  manager$create_signal(
    sender = button,
    receiver = caster,
    value = low_value
  )
  low_value_count <<- low_value_count + 1

  while (length(manager$signals) > 0) {
    manager$consume_next()
  }
}
print(high_value_count * low_value_count)
close(myfile)