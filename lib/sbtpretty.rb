require "sbtpretty/version"
require 'colorize'
require 'open3'
module Sbtpretty
  class Printer
    :info
    :error
    :debug
    :none
    :testfailed
    :alltestspass
    :summaryline
    # ▸ Run completed in 3 seconds, 774 milliseconds
    :runcompleted
    # ▸ Total number of tests run: 59
    :totalNumberOfTestsRun
    # ▸ Suites: completed 9, aborted 0
    :suites
    #▸ Tests: succeeded 58, failed 1, canceled 0, ignored 0, pending 0
    :summary2
    #No tests were executed.
    :no_tests_were_executed

    def get_type(line)
      if no_tests_were_executed(line)
        return :no_tests_were_executed
      end
      if contains_summary_line_type_2(line)
        return :summary2
      end
      if contains_suites(line)
        return :suites
      end
      if contains_total_number_of_test_run(line)
        return :totalNumberOfTestsRun
      end
      if run_completed(line)
        return :runcompleted
      end
      if contains_summary(line)
        return :summaryline
      end

      if contains_date(line)
        return :none
      end

      if contains_failed_test(line)
        return :testfailed
      end

      if contains_all_tests_passed(line)
        return :alltestspass
      end

      if line.start_with?('[INFO]')
        return :info
      end

      if line.start_with?('[info]')
        return :info
      end

      if line.start_with?(' [error]') || line.start_with?('[error]')
        return :error
      end

      if line.start_with?('[ERROR]')
        return :error
      end


      # match_pos = (/\[[0-9]/ =~ line)
      # if match_pos != nil
      #   puts "is not nil"
      #   return :none
      # end


    end
    #  gsed -r "s/[[:cntrl:]]\[[0-9]{1,3}m//g"
    def contains_date(line)
      # [12/18/2017 15:39:10.874]
      return /[0-9]*[\/,:][0-9]*[\/,:][0-9]*.*/.match(line)
    end

    def contains_failed_test(line)
      #*** FAILED ***
      return /\*\*\* .*FAILED.* \*\*\*/.match(line)
    end

    def contains_all_tests_passed(line)
      return /All tests passed/.match(line)
    end

    def contains_summary(line)
      #Passed: Total 5, Failed 0, Errors 0, Passed 5
      return /Passed: Total [0-9]*, Failed [0-9]*, Errors [0-9]*, Passed [0-9]*/.match(line)
    end

    def run_completed(line)
      ## ▸ Run completed in 3 seconds, 774 milliseconds
      return /.*Run completed in .*/.match(line)
    end

    def contains_total_number_of_test_run(line)
      ## ▸ Total number of tests run: 59
      return /.*Total number of tests run.*/.match(line)
    end

    def contains_suites(line)
      # ▸ Suites: completed 9, aborted 0
      #:suites
      return /.*Suites.* completed .* aborted .*/.match(line)
    end

    def contains_summary_line_type_2(line)
      #▸ Tests: succeeded 58, failed 1, canceled 0, ignored 0, pending 0
      return /.*Tests.* succeeded .* failed .*/.match(line)
    end

    def no_tests_were_executed(line)
      # No tests were executed.
      return /.*No tests were executed.*/.match(line)
    end

    WARNING = '⚠️ '
    ERROR = '❌ '
    CHECK = '✅'
    SMALL_ARROW = "▸"
    def strip_info(line)
      return line.gsub(/\[info\] (- )?/,"")
    end

    def format(line,type)
      case type
      when :info then "#{SMALL_ARROW.yellow} #{strip_info(line)}"
      when :error then line.gsub('[error]',"#{ERROR}   ").red
      when :testfailed then line.gsub('[info] ',"#{ERROR}   ").red
      when :alltestspass then line.gsub('[info] ',"#{CHECK}   ").green
      when :runcompleted then "#{SMALL_ARROW.yellow} #{strip_info(line).blue}"
      when :summaryline then "\t#{strip_info(line).yellow}"
      when :totalNumberOfTestsRun then "#{SMALL_ARROW.yellow} #{strip_info(line).blue}"
      when :suites then "#{SMALL_ARROW.yellow} #{strip_info(line).blue}"
      when :summary2 then "#{SMALL_ARROW.yellow} #{strip_info(line).blue}"
      when :no_tests_were_executed then "#{SMALL_ARROW.yellow} #{strip_info(line)}"
      end
    end
    def print(line)
      line = line.chomp
      line = "echo '#{line}' | sed \"s,$(printf '\\033')\\\\[[0-9;]*[a-zA-Z],,g\" 2> /dev/null"
      stdin, stdout, stderr, wait_thr = Open3.popen3(line)
    	val = stdout.gets
    	stdout.close
    	stderr.gets(nil)
    	stderr.close
      if val == nil
        val = ""
      end
      STDOUT.print(format(val,get_type(val)))
      STDOUT.flush
    end
  end
end
