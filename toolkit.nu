def main [] {
  rm .git/ -rf
  git init
  git personal
  make-contributions
  git add *.nu
  git commit -m "The script that made it possible"
  git remote add origin git@github.com:NonlinearFruit/github-messenger.git
  git push -f -u origin HEAD
}

# Original puzzle: https://codegolf.stackexchange.com/q/123526
# Generate the goal file from the text output here: https://codepen.io/jmariner/pen/vZNZEL
export def make-contributions [] {
  let first_sunday_in_generated_graph = '11-24-24'
  let first_sunday_in_target_year = '1-6-13'
  let file_with_text_output = 'goals.txt'
  let offset = ($first_sunday_in_generated_graph | into datetime) - ($first_sunday_in_target_year | into datetime)
  open $file_with_text_output
  | parse '{date}: {count}'
  | update count { into int }
  | update date { into datetime | $in - $offset }
  | each {|pixel|
    0..$pixel.count
    | each {
      commit $pixel.date
    }
    null
  }
  null
}

export def commit [date] {
  $date
  | format date '%Y-%m-%dT12:00:00Z'
  | {
    GIT_AUTHOR_DATE: $in
    #GIT_COMMITTER_DATE: $in
  }
  | with-env $in {
    git commit --allow-empty --allow-empty-message -m ''
  }
}
