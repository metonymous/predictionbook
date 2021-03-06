require File.dirname(__FILE__) + '/../spec_helper'

describe LabelledFormBuilder do
  
  class BogusTemplate
    include ActionView::Helpers::TagHelper
    def text_field(*args); end
    def label(*args); end
    def capture(*args)
      yield.to_s
    end
  end

  before(:each) do
    @errors = mock('errors', :on => nil)
    @record = mock('record', :errors => @errors)
    @template = BogusTemplate.new
    @builder = LabelledFormBuilder.new('record_name', @record, @template, {}, nil)
  end
  
  it 'should add a label to every text field' do
    @template.should_receive(:label).with('record_name', :name, anything, anything)
    @builder.text_field(:name)
  end
  
  it 'should delegate text field to template' do
    @template.should_receive(:text_field).with('record_name', :name, anything)
    @builder.text_field(:name)
  end
  
  it 'should add the error message in the generated field if it has an error' do
    @errors.stub!(:on).with(:name).and_return('error_message')
    @builder.text_field(:name).should =~ /error_message/
  end
  
  it 'should render trailing content after the text field inside the p tag' do
    @template.stub!(:text_field).and_return('textfield')
    @builder.text_field(:name, :trailing_content => '#end').should =~ %r{textfield#end</p>$}
  end
  
end
