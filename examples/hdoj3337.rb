#!/usr/bin/ruby

require 'ojagent'

# Change these two lines
USER = ENV['OJ_USERNAME'] || 'ojagent'
PASS = ENV['OJ_PASSWORD'] || 'ppnn13%dkstFeb.1st'

HDOJ = OJAgent::HDOJAgent.new
HDOJ.login USER, PASS

def code(off)
  return <<-CODE
#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  int n = #{off};
  clock_t cpu;
  size_t mem;
  char* p = NULL;

  while (n-- > 0) {
    getchar();
  }
  n = getchar();
  if (n == EOF) {
    n = 0;
  }

  cpu = ((n >> 4) * 100 + 10) * (CLOCKS_PER_SEC / 1000);
  mem = ((n & 0xF) * 1000 + 10) * 1024;
  p = malloc(mem);
  memset(p, 0xff, mem);
  while (clock() < cpu) {
    p[rand() % mem] = (char)cpu;
  }
  putchar(p[0]);
  free(p);

  return 0;
}
  CODE
end

input = ''
50.times do
  id = HDOJ.submit! '3337', code(input.size), :c
  status = HDOJ.status! id
  ascii = (status[:time].to_i / 100) * 16 + (status[:mem].to_i / 1000)
  break if ascii.zero?
  input << ascii.chr
  puts input
end
p input
