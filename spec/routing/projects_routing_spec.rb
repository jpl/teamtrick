require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectsController do
  describe "route generation" do
    it "maps #index" do
      route_for(:controller => "projects", :action => "index").should == "/projects"
    end
  
    it "maps #new" do
      route_for(:controller => "projects", :action => "new").should == "/projects/new"
    end
  
    it "maps #show" do
      route_for(:controller => "projects", :action => "show", :id => "1").should == "/projects/1"
    end
  
    it "maps #edit" do
      route_for(:controller => "projects", :action => "edit", :id => "1").should == "/projects/1/edit"
    end

  it "maps #create" do
    route_for(:controller => "projects", :action => "create").should == {:path => "/projects", :method => :post}
  end

  it "maps #update" do
    route_for(:controller => "projects", :action => "update", :id => "1").should == {:path =>"/projects/1", :method => :put}
  end
  
    it "maps #destroy" do
      route_for(:controller => "projects", :action => "destroy", :id => "1").should == {:path =>"/projects/1", :method => :delete}
    end

    it "maps #stats_for_date" do
      route_for(:controller => "projects", :action => "stats_for_date", :id => "1", :date => "2099-12-31").should == "/projects/1/stats_for_date/2099-12-31"
    end
  end

  describe "*_path route generation" do
    it_should_map_path 'project_stats_for_date_path(1,"2099-12-31")', "/projects/1/stats_for_date/2099-12-31"
  end

  describe "route recognition" do
    it "generates params for #index" do
      params_from(:get, "/projects").should == {:controller => "projects", :action => "index"}
    end
  
    it "generates params for #new" do
      params_from(:get, "/projects/new").should == {:controller => "projects", :action => "new"}
    end
  
    it "generates params for #create" do
      params_from(:post, "/projects").should == {:controller => "projects", :action => "create"}
    end
  
    it "generates params for #show" do
      params_from(:get, "/projects/1").should == {:controller => "projects", :action => "show", :id => "1"}
    end
  
    it "generates params for #edit" do
      params_from(:get, "/projects/1/edit").should == {:controller => "projects", :action => "edit", :id => "1"}
    end
  
    it "generates params for #update" do
      params_from(:put, "/projects/1").should == {:controller => "projects", :action => "update", :id => "1"}
    end
  
    it "generates params for #destroy" do
      params_from(:delete, "/projects/1").should == {:controller => "projects", :action => "destroy", :id => "1"}
    end

    it "generates params for #stats_for_date" do
      params_from(:get, "/projects/1/stats_for_date/2099-12-31").should == {:controller => "projects", :action => "stats_for_date", :id => "1", :date => "2099-12-31"}
    end
  end
end
