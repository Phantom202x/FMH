import 'package:app/models/auth_models.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthServices {
  Future guestLogin(GuestUser user) async {
    var supabase = Supabase.instance.client;
    var response = await supabase.auth.signInAnonymously(
      data: user.serialize(),
    );
    return response;
  }
  // Hadj Table interactions 
  Future<List<Map<String, dynamic>>> fetchHadjData() async {
    final supabase = Supabase.instance.client;
    final response = await supabase.from('Hadj').select();
    // Optional: check if the response is actually a List
    return response.cast<Map<String, dynamic>>();
    }
  Future<void> HadjRegister(Map<String, dynamic> hadjData) async {
    final supabase = Supabase.instance.client;
    try {
      final response = await supabase.from('Hadj').insert(hadjData);

      // Optional: show a confirmation
      print('Inserted successfully: $response');
    } catch (error) {
      print('Error inserting Hadj: $error');
      throw Exception('Insertion failed');
    }
  }
  Future<void> deleteHadj(String hadjname) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('Hadj')
          .delete()
          .eq('full_name', hadjname); // Replace 'id' with your actual primary key column

      print('Deleted successfully: $response');
    } catch (error) {
      print('Error deleting Hadj: $error');
      throw Exception('Deletion failed');
    }
  }

  Future deleteGuest() async {
    final supabase = Supabase.instance.client;
    final userId = supabase.auth.currentUser?.id;
    
    if (userId != null) {
      final response = await supabase
          .from('Users') // Replace with your actual users table if any
          .delete()
          .eq('id', userId);

      // Delete the auth account (requires service role key - see note below)
      await supabase.auth.signOut();

      return response;
    } else {
      throw Exception("No guest user currently signed in");
    }
  }

  getUserInfos() {
    var supabase = Supabase.instance.client;
    var session = supabase.auth.currentSession;
    Map<String, dynamic>? response;
    if (session!.user.isAnonymous) {
      response = session.user.userMetadata;
    } else {
      response = {"full_name": "Admin", "email": session.user.email};
    }
    return response;
  }

  Future adminLogin(AdminUser user) async {
    var supabase = Supabase.instance.client;
    var response = await supabase.auth.signInWithPassword(
      email: user.email,
      password: user.password,
    );
    return response;
  }

  Future logout() async {
    var supabase = Supabase.instance.client;
    var response = await supabase.auth.signOut();
    return response;
  }
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from('Users') // Make sure table name is exactly 'Users'
          .select();

      // The response is already a List<dynamic>
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print("Error fetching users: $e");
      return [];
    }
  }

  
}


